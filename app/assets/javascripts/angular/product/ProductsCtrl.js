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
        $scope.products.push(response);
      },
      function (response) {
        alert('Errors: ' + response.data.errors.join('. '));
      }
    );
    $scope.product = {};
  };

  $scope.toggleForm = function (product) {
    if (product.id === $scope.editing.id) {
      return 'form';
    }
    else {
      return 'row';
    }
  };

  $scope.hideForm = function () {
    $scope.editing = {};
  };

  $scope.sortProducts = function (sort_by, order) {
    if ($scope.sorting.sort_by == sort_by) {
      order = (order == 'asc' ? 'desc' : 'asc');
    } else if ($scope.sorting.sort_by != sort_by) {
      order = 'asc';
    }
    Product.sort({ sort_by: sort_by, order: order },
      function (response, _headers) {
        $scope.products = response;
        $scope.sorting = {
          sort_by: sort_by,
          order: order
        }
      }
    );
  };

  $scope.updateArrowOrder = function () {
    $scope.order = $scope.sorting.order == 'asc' ? 'up' : 'down';
  };

  $scope.updateArrowOrder();

  $scope.$watch('sorting.order', function (oldVal, newVal) {
    $scope.updateArrowOrder();
  });

  valid = function () {
    return !!$scope.product &&
      !!$scope.product.name && !!$scope.product.product_date &&
      !!$scope.product.description && !!$scope.product.place;
  }
}]);
