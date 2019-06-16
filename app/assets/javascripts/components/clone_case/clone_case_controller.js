'use strict';

/*jslint latedef:false*/

angular.module('QuepidApp')
  .controller('CloneCaseCtrl', [
    '$uibModal',
    '$rootScope',
    '$log',
    'flash',
    'caseSvc',
    'caseTryNavSvc',
    function (
      $uibModal,
      $rootScope,
      $log,
      flash,
      caseSvc,
      caseTryNavSvc
    ) {
      var ctrl = this;

      // Functions
      ctrl.cloneCase  = cloneCase;
      ctrl.prompt     = prompt;

      function cloneCase(options) {
        caseSvc.cloneCase(ctrl.acase, options)
          .then(function(acase) {
            flash.success = 'Case cloned successfully!';
            caseTryNavSvc.navigateTo({
              caseNo: acase.caseNo,
              tryNo:  acase.lastTry
            });
          }, function() {
            flash.error = 'Unable to clone your case, please try again. If the error persists contact support.';
          });
      }

      function prompt() {
        if ( !$rootScope.currentUser.permissions.case.create ) {
          var deniedModalInstance = $uibModal.open({
            templateUrl:  'new_case/_denied_modal.html',
            controller:   'DeniedNewCaseModalInstanceCtrl',
            controllerAs: 'ctrl'
          });

          deniedModalInstance.result.then(
            function() { },
            function() { }
          );
        } else {
          var modalInstance = $uibModal.open({
            templateUrl:  'clone_case/_modal.html',
            controller:   'CloneCaseModalInstanceCtrl',
            controllerAs: 'ctrl',
            resolve:      {
              theCase: function() {
                return ctrl.acase;
              }
            }
          });

          modalInstance.result.then(
            function (options) {
              ctrl.cloneCase(options);
            },
            function() {
              $log.info('INFO: Modal dismissed');
            }
          );
        }
      }
    }
  ]);
