var app = angular.module('angularExample');

app.factory('Product', ['$resource', function($resource) {
  return $resource('/api/products/:id.json', { id: '@id' }, {
    update: { method: 'PUT' },
    search: {
      method: 'GET',
      isArray: true,
      url: '/api/products/search.json',
      params: {
        query: '@query'
      }
    },
    delete: {
      action: 'destroy',
      method: 'DELETE',
      url: '/api/products/:id.json',
      params: {
        id: '@id'
      }
    },
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
