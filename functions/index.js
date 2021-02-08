/* eslint-disable max-len */
/* eslint-disable indent */
/* eslint-disable object-curly-spacing */
"use strict";
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp({
  projectId: "cravy-food",
});

exports.helloWorld = functions.https.onCall((data, context) => {
  return "Hello From Firebase";
});

// Load business info
exports.getBusiness = functions.https.onCall(async (data, context) => {
  try {
    const id = context.auth.uid;
    const doc = await admin.firestore().collection("businesses").doc(id).get();
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
