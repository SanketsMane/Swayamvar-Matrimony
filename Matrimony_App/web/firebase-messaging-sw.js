importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js');

firebase.initializeApp({
  apiKey: "AIzaSyDkkMtp-S32Sgz8wbH7Tmo7RE82IdUwP90",
  projectId: "swayamvar-e2a6d",
  messagingSenderId: "927257142657",
  appId: "1:927257142657:web:4c4ce6e334ac7668717480", // Sanket: Should match firebase_options.dart
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/favicon.png'
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});
