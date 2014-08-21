(function() {

  initProvince = function(){
    var currentEL = $('#provinceId');
    var provinceId = currentEL.val();
    getCities(currentEL, provinceId);
  };

  changeProvince = function(){
    $('#provinceId').change(function(){
      var currentEL = $(this);
      var provinceId = currentEL.val();
      getCities(currentEL, provinceId);
    });
  };

  changeCity = function(){
    $('#cityId').change(function(){
      var cityId = $(this).val();
      getMarkets(cityId);
    });
  };

  getCities = function(currentEL, provinceId){
    if(provinceId != undefined || $.trim(provinceId) != ''){
      $.ajax({
        url: '/provinces/' + provinceId + '/cities',
        type: 'GET',
        success: function(resp){
          if(resp != null){
            var options = '';
            $.each(resp, function(i, value){
              var name = value[1];
              var text = value[0];
              if(i == 0){
                options += '<option value="'+ name +'" selected>' + text + '</option>';
              }else{
                options += '<option value="'+ name +'">' + text + '</option>';
              }
            });
            $('#cityId').empty().append(options);
            // jquery mobile set select default value
            var cityName;
            if(resp.length > 0){
              cityName = resp[0][0];
              getMarkets(resp[0][1]);
            }else{
              cityName = currentEL.siblings('span').text();
            }
            $('#cityId').siblings('span').html(cityName);
          }
        }
      });
    }
  };

  getMarkets = function(cityId){
    if(cityId != 'no' && cityId != undefined){
      $.ajax({
        url: '/cities/' + cityId + '/markets',
        type: 'GET',
        success: function(resp){
          if(resp != null){
            var options='';
            $.each(resp, function(i, value){
              var name = value[1];
              var text = value[0];
              if(i == 0){
                options += '<option value="'+ name +'" selected>' + text + '</option>';
              }else{
                options += '<option value="'+ name +'">' + text + '</option>';
              }
            });
            
            $('#marketId').empty().append(options);
            var marketName;
            if(resp.length > 0){
              marketName = resp[0][0];
            }else{
              marketName = '&nbsp;';
            }
            $('#marketId').siblings('span').html(marketName);
          }
        }
      });
    }
  };

  initProvince();
  changeProvince();
  changeCity();

}).call(this);