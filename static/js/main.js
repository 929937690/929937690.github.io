// Get the back-to-top button
let back2topbutton = document.getElementById("btn-back-to-top");

// Function that shows the back-to-top button when the user scrolls down 20px from the top
window.onscroll = function () {
  scrollFunction();
};

function scrollFunction() {
  // If the user scrolls down more than 20px, show the back-to-top button
  if (
    document.body.scrollTop > 20 ||
    document.documentElement.scrollTop > 20
  ) {
    back2topbutton.style.display = "block";
  } else {
    // Otherwise, hide the back-to-top button
    back2topbutton.style.display = "none";
  }
}

// Function that scrolls to the top of the document when the back-to-top button is clicked
back2topbutton.addEventListener("click", backToTop);

function backToTop() {
  window.scrollTo({
    top: 0,
    behavior: "smooth"
  });
}

// Function that toggles the background color of the container
function toggleBackgroundColor() {
  document.getElementById('toggleBackgroundButton').addEventListener('click', function() {
      const container = document.querySelector('.container-fluid');
      container.classList.toggle('grey-background');
  });
}

// Add event listener for DOMContentLoaded to call toggleBackgroundColor
document.addEventListener('DOMContentLoaded', toggleBackgroundColor);

// Function that submits and resets the contact form
function submitFormAndReset() {
  const form = document.getElementById('contact-form');
  // Check if the form is valid
  if (form.checkValidity()) {
      // If the form is valid, submit and reset the form
      form.submit();
      form.reset();
  } else {
      // If the form is not valid, display validation error messages
      form.reportValidity();
  }
}


// Get the button
// let darklightbutton = document.getElementById("btn-dark-light");

// darklightbutton.addEventListener("click", switchmode);
// function switchmode() {
//   color = "grey"
//   document.getElementsByClassName('container-fluid').style.backgroundColor = color;
// }