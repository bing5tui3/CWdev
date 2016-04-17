function OnMouseChangeBackgroundColor(elementID, newBackgroundColor, newTextColor) {
  var object = document.getElementById(elementID);
  var oldBackgroundColor = object.style.background;
  var oldTextColor       = object.style.color;
  object.addEventListener('mouseover', function(e) {
    ChangeElementColor(e, newBackgroundColor, newTextColor);
  }, false);
  object.addEventListener('mouseout', function(e) {
    ChangeElementColor(e, oldBackgroundColor, oldTextColor);
  }, false);
}

function ChangeElementColor(e, backgroundColor, textColor) {
  var target = e.target;
  target.style.background = backgroundColor;
  target.style.color      = textColor;
}

function EquateLineHeight(elementID1, elementID2) {
  var rowHeight = document.getElementById(elementID1).clientHeight;
  var colHeight = document.getElementById(elementID2).clientHeight;
  var margin = (rowHeight - colHeight) / 2.0;
  document.getElementById(elementID2).style.marginTop = margin + 'px';
}
