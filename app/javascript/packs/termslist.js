// console.log('Terms List js');
window.onload = function () {
  var searchBtn = document.getElementById('btnSearch');
  var textTerms = document.getElementById('textTerm');

  if (searchBtn) {
    var savedTerms = [];
    if (localStorage.getItem('terms') != null) {
      var items = localStorage.getItem('terms');
      savedTerms = JSON.parse(items);
      // console.log(' test', savedTerms);
      searchBtn.addEventListener('click', () => {
        savedTerms.push(textTerms.value);
        localStorage.setItem('terms', JSON.stringify(savedTerms));
      });
      renderList(savedTerms);
    } else {
      var ul = document.createElement('ul');
      document.getElementById('lastSearches').appendChild(ul);
      var listil = document.createElement('li');
      ul.appendChild(listil);
      listil.innerHTML += 'No searches!';
      searchBtn.addEventListener('click', () => {
        savedTerms.push(textTerms.value);
        localStorage.setItem('terms', JSON.stringify(savedTerms));
      });
    }
  }
  function renderList(item) {
    var ul = document.createElement('ul');
    document.getElementById('lastSearches').appendChild(ul);
    lastfive = item.slice(Math.max(item.length - 5, 0));
    lastfive.reverse();
    for (let items of lastfive) {
      console.log(items);
      var listil = document.createElement('li');
      ul.appendChild(listil);
      listil.innerHTML += items;
    }
  }
};
