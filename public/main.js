let sortedOn = -1

function SortTable(sortOn) {
  const table = document.getElementById('table_files')
  const tbody = table.getElementsByTagName('tbody')[0]
  const rows = tbody.getElementsByTagName('tr')
  let rowArray = new Array()
  for (let i = 0, length = rows.length; i < length; i++) {
    rowArray[i] = new Object
    rowArray[i].oldIndex = i
    rowArray[i].value = rows[i].getElementsByTagName('td')[sortOn].children[0].value
  }
  if (sortOn == sortedOn) {
    rowArray.reverse()
  } else {
    sortedOn = sortOn
    if(sortOn == 1 || sortOn == 2) {
      rowArray.sort(RowCompareNumbers)
    } else {
      rowArray.sort(RowCompareString)
    }
  }
  var newTbody = document.createElement('tbody')
  for (let i = 0, length = rowArray.length; i < length; i++) {
    newTbody.appendChild(rows[rowArray[i].oldIndex].cloneNode(true))
  }
  table.replaceChild(newTbody, tbody)
}

function RowCompareString(a, b) {
  var aVal = a.value.toLowerCase()
  var bVal = b.value.toLowerCase()
  return aVal.localeCompare(bVal)
}

function RowCompareDefault(a, b) {
  var aVal = a.value.toLowerCase()
  var bVal = b.value.toLowerCase()
  return (aVal == bVal ? 0 : (aVal > bVal ? 1 : -1))
}

function RowCompareNumbers(a, b) {
  var aVal = parseInt( a.value)
  var bVal = parseInt(b.value)
  return (aVal - bVal)
}
