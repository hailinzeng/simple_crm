(function() {

  changeProvince = function(){
    $('#provinceId').change(function(){
      var currentEL = $(this);
      var provinceId = currentEL.val();
      $.ajax({
        url: '/provinces/' + provinceId + '/cities',
        type: 'GET',
        success: function(resp){
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
          $('#cityId').empty().append(options);
          // jquery mobile set select default value
          var cityName;
          if(resp.length > 0){
            cityName = resp[0][0];
          }else{
            cityName = currentEL.siblings('span').text();
          }
          $('#cityId').siblings('span').html(cityName);
        }
      });
    });
  };

  changeProvince();
}).call(this);