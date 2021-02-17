/* eslint-disable space-before-function-paren */
/* eslint-disable max-len */
/* eslint-disable indent */
/* eslint-disable object-curly-spacing */
"use strict";
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp({
  projectId: "cravy-food",
});

// Load business info
exports.getBusiness = functions.https.onCall(async (_, context) => {
  try {
    const doc = await admin
      .firestore()
      .collection("businesses")
      .doc(context.auth.uid)
      .get();
    if (doc.exists) {
      return doc.data();
    } else {
      throw new functions.https.HttpsError(
        "not-found",
        "The requested document was not found"
      );
    }
  } catch (error) {
    console.log(error);
    throw error;
  }
});

// Load Business Products
exports.getBusinessProducts = functions.https.onCall(async (data, context) => {
  try {
    // Get collection of the product references
    const productRefCollectionQuery = admin
      .firestore()
      .collection("businesses")
      .doc(context.auth.uid)
      .collection("products")
      .where("state", "==", data.state)
      .orderBy("date_created", "desc");
    let productRefSnapshot;
    if (data.last) {
      const ts = admin.firestore.Timestamp.fromMillis(_toTimestamp(data.last));
      productRefSnapshot = await productRefCollectionQuery
        .startAfter(ts)
        .limit(data.limit)
        .get();
    } else {
      productRefSnapshot = await productRefCollectionQuery
        .limit(data.limit)
        .get();
    }
    // check if there are any products
    if (productRefSnapshot.empty) {
      return;
    } else {
      // FirebaseFirestore.QuerySnapshot<FirebaseFirestore.DocumentData>
      // const s = FirebaseFirestore.QuerySnapshot<FirebaseFirestore.DocumentData>()
      const [lastDoc] = productRefSnapshot.docs.slice(-1);
      const productPromises = []; // Will contain the promises for resolving all the products data
      productRefSnapshot.forEach((doc) => {
        const productRef = doc.data().product_ref; // Get the reference of a product data
        productPromises.push(_getProduct(productRef.path)); // Add the promise of getting the product data by using the reference path
      });
      const allProducts = await Promise.all(productPromises); // Asynchronously fetch each product data. Will be stored in an array.
      // console.log(allProducts);
      return {
        all: allProducts,
        last: lastDoc.data().date_created,
      };
    }
  } catch (error) {
    console.log(error);
    throw error;
  }
});

// Load the product data using the path in which the data is stored in the cloud firestore.
const _getProduct = async function (path) {
  const doc = await admin.firestore().doc(path).get(); // The document reference to the product data
  const product = doc.data();
  product.id = doc.id;
  return product;
};

// Update Product state
exports.updateProductState = functions.https.onCall(async (data, context) => {
  try {
    await admin
      .firestore()
      .collection("businesses")
      .doc(context.auth.uid)
      .collection("products")
      .doc(data.id)
      .update({ state: data.state });
    await admin
      .firestore()
      .collection("products")
      .doc(data.id)
      .update({ state: data.state });
    return data.state;
  } catch (error) {
    console.log(error);
    throw error;
  }
});

// Load market status of a product
exports.getMarketStatus = functions.https.onCall(async (data, context) => {
  try {
    const doc = await admin
      .firestore()
      .collection("businesses")
      .doc(context.auth.uid)
      .collection("products")
      .doc(data.id)
      .get();
    const productData = doc.data();
    return {
      searches: productData.searches,
      views: productData.views,
      visits: productData.visits,
    };
  } catch (error) {
    console.log(error);
    throw error;
  }
});

// Set the promotion status of the product
exports.setPromotion = functions.https.onCall(async (data, context) => {
  try {
    await admin
      .firestore()
      .collection("businesses")
      .doc(context.auth.uid)
      .collection("products")
      .doc(data.id)
      .update({ is_promoted: data.is_promoted });
    await admin
      .firestore()
      .collection("products")
      .doc(data.id)
      .update({ is_promoted: data.is_promoted });
    return data.is_promoted;
  } catch (error) {
    console.log(error);
    throw error;
  }
});

// Update the product with the provided information
exports.updateProduct = functions.https.onCall(async (data, _) => {
  try {
    if (Object.keys(data.update).length) {
      await admin
        .firestore()
        .collection("products")
        .doc(data.id)
        .update(data.update);
    }
    return data.update;
  } catch (error) {
    console.log(error);
    throw error;
  }
});

// Delete a product
exports.deleteProduct = functions.https.onCall(async (data, context) => {
  try {
    await Promise.all(
      admin
        .firestore()
        .collection("businesses")
        .doc(context.auth.uid)
        .collection("products")
        .doc(data.id)
        .delete(),
      admin.firestore().collection("products").doc(data.id).delete()
    );
    return data.id;
  } catch (error) {
    console.log(error);
    throw error;
  }
});

const _toTimestamp = (obj) => {
  return obj._seconds * 1000 + obj._nanoseconds / 1000000;
};
