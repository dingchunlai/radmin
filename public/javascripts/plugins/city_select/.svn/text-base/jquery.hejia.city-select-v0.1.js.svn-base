;(function($) {
  $.fn.extend({
    "CitySelectTag": function(options){
      var $wrapper = $(this),
      options = $.extend({
        province_name: "province",
        city_name: "city",
        city_include_blank: false
      },options);
      
      init(options.province_name,options.city_name);
      var $province = $("select[name='" + options.province_name + "']");
      var $city = $("select[name='" + options.city_name + "']");
      function init(province_name,city_name) {
        
         $wrapper.append("省/市:<select class='required' name=" +province_name + "><option value=''>请选择</option></select>" );
         $wrapper.append("市/区:<select class='required' name=" + city_name + "><option value=''>请选择</option></select>" );
         $.getJSON('/ajax_city/get_province',function(data) {
           parse_json($province,data);
           $province.select_it("data-province");
           get_city(true);
         });
      };
      
      jQuery.fn.select_it = function(attr_name){
        var index = this.children('[value='+$wrapper.attr(attr_name)+']').index();
        if (index>=0) {
          this.attr("selectedIndex", index);
        };
      };

      $province.change(function() {
         get_city();
      });
      
      function get_city(value) {
          $.getJSON('/ajax_city/get_city', {province: $province.val()}, function(data) {
            parse_json($city,data);
            if (value == true) {$city.select_it("data-city");};
          });
      };
      
      function blank_option(text) {
        if (text == true) {
          return "<option value=''>请选择</option>"
        }else{
          return "<option value=''>" + text + "</option>"
        };
      };
      
      
      
      function parse_json(select,data) {
        if (select == $city && $province.val()==""){
          return true;
        }else{
          if (select == $city) {
            $city.empty();
          };
           $.each(data,function(i){
              select[0].options.add(new Option(data[i][1],data[i][0]));
           });
        };
      };
      
      
    }
  });
})(jQuery);