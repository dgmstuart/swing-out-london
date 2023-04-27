export function initSieveTable(inputSelector, tableSelector) {
  const input = document.querySelector(inputSelector);
  const table = document.querySelector(tableSelector);
  if (table === null) return;

  input.addEventListener("keyup", () => {
    sieveTable(input, table);
  });
}

export function initSieveList(inputSelector, listSelector) {
  const input = document.querySelector(inputSelector);
  const list = document.querySelector(listSelector);
  if (list === null) return;

  input.addEventListener("keyup", () => {
    sieveList(input, list);
  });
}

function sieveList(input, list) {
  const filter = input.value.toLowerCase();
  var items = list.getElementsByTagName("li");

  for(var item of items) {
    const itemText = item.textContent || item.innerText;
    if (itemText.toLowerCase().indexOf(filter) > -1) {
      item.style.display = "";
    } else {
      item.style.display = "none";
    }
  }
}

function sieveTable(input, table) {
  const filter = input.value.toLowerCase();
  var rows = table.getElementsByTagName("tr");
  for(var row of rows) {
    const cells = row.getElementsByTagName("td");

    for(var cell of cells) {
      const cellText = cell.textContent || cell.innerText;
      if (cellText.toLowerCase().indexOf(filter) > -1) {
        row.style.display = "";
        break; // If we have a match, *anywhere*, don't hide, and break so that we stop looking
      } else {
        row.style.display = "none";
      }
    }
  }
}
