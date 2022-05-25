/* eslint-disable max-len */
const functions = require("firebase-functions");

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions


const admin = require("firebase-admin");

admin.initializeApp(functions.config());


// const db = admin.firestore();

exports.userNotifications = functions.firestore
    .document("notifications/yBlfDOUJ9hair4CP2aC4/utilisateurs/{id_notifications}")
    .onUpdate((snapshot, context) => {
        const value = snapshot.after.data();
        const Uid = context.params.id_notifications;
        // console.log(value);
        // console.log(Uid);
    });


exports.videoCallNotif = functions.firestore
    .document("notifications/yBlfDOUJ9hair4CP2aC4/chatNotifications/{channel}")
    .onCreate((snapshot) => {
        const value = snapshot.data();
        const sound = "mixkit_bell_notification_933.wav";

        const payload = {
            notification: {
                title: value.title,
                body: value.body,
                clickAction: "FLUTTER_NOTIFICATION_CLICK",
                sound: sound,
            },
        };
        admin.messaging().sendToTopic(value.topic_receiver, payload);
    });

exports.userComeBackNotif = functions.firestore
    .document("notifications/yBlfDOUJ9hair4CP2aC4/praticiens/{channel}")
    .onCreate((snapshot) => {
        const value = snapshot.data();
        const sound = "mixkit_bell_notification_933.wav";
        const payload = {
            notification: {
                title: value.title,
                body: value.body,
                clickAction: "FLUTTER_NOTIFICATION_CLICK",
                sound: sound,
            },
            data: {
                id_consultation: value.channel,
                pratician_receiver: value.pratician_receiver,
                user_receiver: value.user_receiver,
                route_name: value.route_name,
            },
        };
        admin.messaging().sendToTopic(value.topic_receiver, payload);
    });


exports.newDemandeNotif = functions.firestore
    .document("notifications/yBlfDOUJ9hair4CP2aC4/demandes/{channel}")
    .onCreate((snapshot) => {
        const value = snapshot.data();
        const sound = "mixkit_bell_notification_933.wav";
        const payload = {
            notification: {
                title: value.title,
                body: value.body,
                clickAction: "FLUTTER_NOTIFICATION_CLICK",
                sound: sound,
            },
            data: {
                route_name: "demande_screen",
            },
        };
        // admin.messaging().sendToTopic(value.demande_departement, payload);
        admin.messaging().sendToTopic("newDemande", payload);
    });

exports.newUserPrescriptNotif = functions.firestore
    .document("notifications/yBlfDOUJ9hair4CP2aC4/utilisateurs/{channel}")
    .onCreate((snapshot) => {
        const value = snapshot.data();
        const sound = "mixkit_bell_notification_933.wav";

        const payload = {
            notification: {
                title: value.title,
                body: value.body,
                clickAction: "FLUTTER_NOTIFICATION_CLICK",
                sound: sound,
            },
            data: {
                id_consultation: value.channel,
                pratician_email: value.pratician_email,
                user_receiver: value.user_receiver,
                route_name: value.route_name,
            },
        };
        admin.messaging().sendToTopic(value.topic_receiver, payload);
    });