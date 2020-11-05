var app = angular.module('angularExample');
app.controller('ProductsCtrl', ['$scope', 'Product', function ($scope, Product) {
  $scope.products = Product.query();
  $scope.editing = {};
  $scope.sorting = {
    sort_by: 'name',
    order: 'asc'
  }
  $scope.addProduct = function () {
    Product.save($scope.product,
      function (response, _headers) {
        $scope.products.unshift(response);
      },
      function (response) {
        alert('Errors: ' + response.data.errors.join('. '));
      }
    );
  };

  $scope.toggleForm = function (product) {
    if (product.id === $scope.editing.id) {
      return 'form';
    }
    else {
      return 'row';
    }
  };

  $scope.sortProducts = function () {
    Product.sort(
      function (response, _headers) {
        $scope.products = response;
      }
    );
  };
}]);