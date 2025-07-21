/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {setGlobalOptions} = require("firebase-functions");
const {onRequest} = require("firebase-functions/https");
const logger = require("firebase-functions/logger");

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.notifyAidantsOnNewDemande = functions.firestore
  .document('demandes/{uid}')
  .onCreate(async (snap, context) => {
    const demande = snap.data();

    const title = 'Nouvelle demande d’aide';
    const body = '${demande.titre} - ${demande.categorie} (${demande.lieu})';

    const payload = {
      notification: {
        title,
        body,
        sound: 'default',
      },
    };

    const usersSnapshot = await admin.firestore()
      .collection('users')
      .where('role', '==', 'aidant')
      .get();

    const tokens = usersSnapshot.docs
      .map(doc => doc.data().fcmToken)
      .filter(token => !!token);

    if (tokens.length === 0) {
      console.log("Aucun token FCM trouvé.");
      return null;
    }

    const response = await admin.messaging().sendToDevice(tokens, payload);
    console.log('Notifications envoyées à', tokens.length, 'aidants');
    return response;
  });