//feedbackFormValidate.js
//Functions to perform data validation on data entered by
//the user into the feedback form, and to display appropriate
//error messages if problems with the data are discovered

function contactFromValid(contactFormObj) {

  var firstName = contactFormObj.firstName.value;
  var lastName = contactFormObj.lastName.value;
  var phone = contactFormObj.phone.value;
  var email = contactFormObj.email.value;
  var subject = contactFormObj.subject.value;
  var message = contactFormObj.message.value;
  var agree = contactFormObj.agree.checked;
  rate = getRadioValue();
  allpass = true

  if (!validateName(firstName)) {
    alert("Error on firstName: " + contactFormObj.firstName.title);
    allpass = false;
  }
  if (!validateName(lastName)) {
    alert("Error on lastName: " + contactFormObj.lastName.title);
    allpass = false;
  }
  if (!validatePhone(phone)) {
    alert("Error on phone: " + contactFormObj.phone.title);
    allpass = false;
  }
  if (!validateEmail(email)) {
    alert("Error on email: " + contactFormObj.email.title);
    allpass = false;
  }
  if (!subject) {
    alert("Error on subject: " + contactFormObj.subject.title);
    allpass = false;
  }
  if (!message) {
    alert("Error on message: " + contactFormObj.message.title);
    allpass = false;
  }
  if (!agree) {
    alert("Error on agreement: " + contactFormObj.agree.title);
    allpass = false;
  }

  return allpass
}

function validateName(name) {
  var pattern = name.search(/^[A-Z][a-z]+$/);
  if (pattern == 0)
    return true;
  else
    return false;
}

function validatePhone(phone) {
  var pattern = phone.search(/^(\d{3}-)?\d{3}-\d{4}$/);
  if (pattern == 0)
    return true;
  else
    return false;
}

function validateEmail(address) {
  var pattern = address.search(/^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})$/);
  if (pattern == 0)
    return true;
  else
    return false;
}

function getRadioValue() {
  var ele = document.getElementsByName('rate');

  for (i = 0; i < ele.length; i++) {
    if (ele[i].checked)
      return ele[i].value;
  }
  return null
}

function contactFormProcess() {
  var contactFormObj = document.getElementById("contactForm");
  if (contactFromValid(contactFormObj)) {
    textToDisplay = summarizeContent(contactFormObj);
    var feedbackDisplay = window.open("", "",
      "width=1500, height=100, top=300, left=300");
    feedbackDisplay.document.write(textToDisplay);
  }
  
}

function summarizeContent(contactFormObj){
  var date = contactFormObj.todayDate.value;
  var salutation = contactFormObj.salutation.value;
  var firstName = contactFormObj.firstName.value;
  var lastName = contactFormObj.lastName.value;
  var phone = contactFormObj.phone.value;
  var email = contactFormObj.email.value;
  var enrolled = contactFormObj.enrolled.checked;
  var subject = contactFormObj.subject.value;
  var message = contactFormObj.message.value;
  var rate = getRadioValue();

  textToDisplay = 
  "(Message Content Summary )\n" +
  "(Date: " + date + 
  ")\n" +
  "(\tName: " + salutation + firstName + " " + lastName +
  ")\n" +
  "(\tPhone: " + phone + 
  ")\n" +
  "(\tEmail: " + email + 
  ")\n" +
  "(\tEnroll Status: " + enrolled + 
  ")\n" +
  "(\tSubject: " + subject + 
  ")\n" +
  "(\tMessage: " + message + 
  ")\n" +
  "(\tRate Score: " + rate + 
  ")\n"

  return textToDisplay;
}