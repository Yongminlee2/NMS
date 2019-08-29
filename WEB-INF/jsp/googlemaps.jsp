<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
	<head>
	<title>Places Autocomplete</title>
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
	<meta charset="utf-8">
	<link href="https://developers.google.com/maps/documentation/javascript/examples/default.css" rel="stylesheet">
	<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDaycUH27Zs4ctXbxQm32V0sBb27IA2BzQ&v=3.exp&sensor=false&libraries=places"></script>

	<style>
	input { border: 1px solidrgba(0, 0, 0, 0.5); }
	input.notfound { border: 2px solidrgba(255, 0, 0, 0.4); }
	</style>

	<script>
		function initialize() {
			var mapOptions = {
				center: new google.maps.LatLng(36.5579185, 127.872406),
				zoom: 7,
				disableDefaultUI:true,
				mapTypeId: google.maps.MapTypeId.HYBRID 
			};
			
			var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

			var markLocation = new google.maps.LatLng(36.5579185, 127.872406);
			
			var size_x = 60; // 마커로 사용할 이미지의 가로 크기
			var size_y = 60; // 마커로 사용할 이미지의 세로 크기
			
			var image = new google.maps.MarkerImage( 'http://www.larva.re.kr/home/img/boximage3.png',
						new google.maps.Size(size_x, size_y),
						'',
						'',
						new google.maps.Size(size_x, size_y));
			
			var marker = new google.maps.Marker({
						position: markLocation, // 마커가 위치할 위도와 경도(변수)
						map: map,
						icon: image, // 마커로 사용할 이미지(변수)
						// info: '말풍선 안에 들어갈 내용',
						title: '서대전네거리역이지롱~' // 마커에 마우스 포인트를 갖다댔을 때 뜨는 타이틀
			});

			var content = "이곳은 서대전네거리역이다! <br/> 지하철 타러 가자~"; // 말풍선 안에 들어갈 내용
			var infowindow = new google.maps.InfoWindow({ content: content});
			 
			google.maps.event.addListener(marker, "click", function() {
				infowindow.open(map,marker);
			});
		}
 
		google.maps.event.addDomListener(window, 'load', initialize);
 
</script>
</head>
<body>
<input id="address" type="text" size="50"> 
<div id="map-canvas" style="width:600px;height:600px;"></div>
</body>
</html>