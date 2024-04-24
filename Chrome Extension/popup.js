document.addEventListener("DOMContentLoaded", function () {
  const saveButton = document.getElementById("safePassButton");
  const inputValue = document.getElementById("safePassKey");

  // Fetch value from local storage and set to input field
  inputValue.value = "";

  const items = new Promise((resolve) => {
    chrome.storage.sync.get(["safePassKey"], function (items) {
      resolve(items);
    });
  });

  items.then((items) => {
    inputValue.value = items.safePassKey || "";
  });

  saveButton.addEventListener("click", function () {
    const value = inputValue.value;
    chrome.storage.sync.set({ safePassKey: value }, function () {
      alert(`Value "${value}" saved to local storage.`);
    });
  });
});
