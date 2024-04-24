const apiURL = "http://localhost:5000/api/create_password";

document.addEventListener("submit", async function (event) {
  // Prevent the default form submission
  event.preventDefault();

  // Get the current URL
  const website = window.location.href;

  // Get all input fields from the form
  const inputFields = document.querySelectorAll("input");

  // Collect values of input fields
  let username = "";
  let password = "";
  let additionalFields = {};

  var containsUsername = false;
  var containsPassword = false;

  inputFields.forEach((input) => {
    if (input.type === "username" || input.type === "email") {
      containsUsername = true;
      username = input.value;
    } else if (input.type === "password") {
      containsPassword = true;
      password = input.value;
    } else {
      additionalFields[input.name] = input.value;
    }
  });

  // If the form does not contain a username or password field, dont proceed further

  if (!containsUsername || !containsPassword) {
    return;
  }

  // Create the JSON object
  const formData = {
    website: website,
    username: username ? username : null,
    user: null, // This will be updated by the message from the popup
    password: password ? password : null,
    isActive: true,
    additionalData: additionalFields,
  };

  // Wait for the localValue to be received from the popup
  const localValue = await new Promise((resolve) => {
    chrome.storage.sync.get(["safePassKey"], function (items) {
      resolve(items.safePassKey || null);
    });
  });

  // Update the formData with the received localValue
  formData.user = localValue ? localValue : null;

  // Log or use the updated formData
  // console.log(formData);

  // Send the formData to the API

  fetch(apiURL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      // Add any other headers if needed
    },
    body: JSON.stringify({
      password: formData.password,
      website: formData.website,
      username: formData.username,
      user: formData.user ? formData.user : "", // Assuming userData.email is available in formData.localValue
      isActive: true,
      additionalData: formData.additionalData,
    }),
  })
    .then((response) => response.json())
    .then((data) => {
      // console.log("Success:", data);
      alert("Credentials saved successfully!");
    })
    .catch((error) => {
      // console.error("Error:", error);
      // alert("Error submitting form. Please try again.");
    });

  // alert("Form submitted!");
});
