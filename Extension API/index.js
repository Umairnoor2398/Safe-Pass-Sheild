const admin = require("firebase-admin");
const express = require("express");
const cors = require("cors");
const PORT = 5000;

const app = express();

app.use(cors({ origin: true }));
app.use(express.json()); // Add this line to parse JSON requests

var serviceAccount = require("./permissions.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

app.post("/api/create_password", async (req, res) => {
  // Add async here
  try {
    console.log(req.body);
    const userRef = await db
      .collection("Users")
      .where("salt", "==", req.body.user)
      .get();

    if (userRef.empty) {
      return res.status(404).send("User not found");
    }

    var userData = userRef.docs[0].data();

    console.log(userData);

    console.log(userData.email);

    if (userData.email == null || userData.email == undefined) {
      return res.status(404).send("User not found");
    }

    const passRef = db.collection("Passwords").doc();
    await passRef.set({
      password: req.body.password,
      website: req.body.website,
      username: req.body.username,
      user: userData.email,
      isActive: true,
      additionalData: req.body.additionalData,
      //   additionalData: { key: "value", key2: "value2" },
    });

    // .create({ password: req.body.password });
    return res.status(200).send();
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
