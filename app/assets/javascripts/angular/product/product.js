var app = angular.module('angularExample');

app.factory('Product', ['$resource', function ($resource) {
  return $resource('/api/products/:id.json', { id: '@id' }, {
    
    update: { method: 'PUT' },

    sort: {
      action: 'index',
      method: 'GET',
      isArray: true,
      url: '/api/products.json',
      params: {
        sort_by: '@sort_by',
        order: '@order'
      }
    }
  });
}]);
