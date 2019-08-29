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
			
			var size_x = 60; // ��Ŀ�� ����� �̹����� ���� ũ��
			var size_y = 60; // ��Ŀ�� ����� �̹����� ���� ũ��
			
			var image = new google.maps.MarkerImage( 'http://www.larva.re.kr/home/img/boximage3.png',
						new google.maps.Size(size_x, size_y),
						'',
						'',
						new google.maps.Size(size_x, size_y));
			
			var marker = new google.maps.Marker({
						position: markLocation, // ��Ŀ�� ��ġ�� ������ �浵(����)
						map: map,
						icon: image, // ��Ŀ�� ����� �̹���(����)
						// info: '��ǳ�� �ȿ� �� ����',
						title: '�������װŸ���������~' // ��Ŀ�� ���콺 ����Ʈ�� ���ٴ��� �� �ߴ� Ÿ��Ʋ
			});

			var content = "�̰��� �������װŸ����̴�! <br/> ����ö Ÿ�� ����~"; // ��ǳ�� �ȿ� �� ����
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