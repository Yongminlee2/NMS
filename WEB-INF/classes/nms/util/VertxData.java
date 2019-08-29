package nms.util;

import java.util.HashMap;
import java.util.List;

import nms.monitoring.service.DatareceivedService;
import nms.monitoring.service.WaveService;
import nms.monitoring.vo.WaveChartDataVO;
import nms.monitoring.vo.WaveMapDataVO;
import nms.quakeoccur.vo.QuakeEventListVO;
import nms.quakeoccur.vo.SelfEventListVO;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.vertx.java.core.Handler;
import org.vertx.java.core.Vertx;
import org.vertx.java.core.http.HttpServer;
import org.vertx.java.core.json.JsonObject;

import com.nhncorp.mods.socket.io.SocketIOServer;
import com.nhncorp.mods.socket.io.SocketIOSocket;
import com.nhncorp.mods.socket.io.impl.DefaultSocketIOServer;
import com.nhncorp.mods.socket.io.spring.DefaultEmbeddableVerticle;
 
@Controller
public class VertxData extends DefaultEmbeddableVerticle {
	private static SocketIOServer io = null;
	private static HashMap roomList;
	private static HashMap socketIdMap;
	private static HashMap socketIdChart;
	private static HashMap socketIdAlarm;
	
	
	long timerID;
	
	/*@Autowired
	SocketService socketService;*/
	
	@Autowired
	WaveService waveService;
	
	@Autowired
	DatareceivedService datareceivedService;

	@Override
	public void start(final Vertx vertx){
		roomList = new HashMap();
		socketIdMap = new HashMap();
		socketIdChart = new HashMap();
		socketIdAlarm = new HashMap();
		
		int port = 1809;
		HttpServer server = vertx.createHttpServer();
		
		io = new DefaultSocketIOServer(vertx, server);
		io.sockets().onConnection(new Handler<SocketIOSocket>() {
			public void handle(final SocketIOSocket socket) {
				/*
				 * 지도 서비스를 위한 입장
				 * */
				socket.on("maproomjoin", new Handler<JsonObject>() { 
					public void handle(JsonObject data) {
						String room = data.getString("room");
						socket.join(room);
						socketIdMap.put(socket.getId(), room);
						io.sockets().in(room).emit("maproomjoinok", "ok");
					}
				});
				
				/*
				 * 지도 서비스를 위한 퇴장
				 * */
				socket.on("maproomout", new Handler<JsonObject>() { 
					public void handle(JsonObject data) { 
						String room = data.getString("room");
						if(io.sockets().manager().rooms().get("/"+room).size() == 1)
						{
							if(roomList.get(room) != null)
							{
								long roomTimer = Long.parseLong(roomList.get(room).toString());
								vertx.cancelTimer(roomTimer);
								roomList.remove(room);
								socketIdMap.remove(socket.getId());
							}
							
						}
						socket.leave(room);
						
					}
				});
				
				/*
				 * 차트 서비스를 위한 입장
				 * */
				socket.on("chartroomjoin", new Handler<JsonObject>() { 
					public void handle(JsonObject data) {
						
						String room = data.getString("room");
						String name = data.getString("name");
						socket.join(room);
						
						socketIdChart.put(socket.getId(), room);
						
						JsonObject jo = new JsonObject();
						jo.putString("staType", room);
						jo.putString("name", name);
						jo.putString("result", "ok");
						
						io.sockets().in(room).emit("chartroomjoinok", jo);
					}
				});
				
				/*
				 * 차트 서비스를 위한 퇴장
				 * */
				socket.on("chartroomout", new Handler<JsonObject>() { 
					public void handle(JsonObject data) { 
						String room = data.getString("room");
						if(io.sockets().manager().rooms().get("/"+room).size() == 1)
						{
							if(roomList.get(room) != null)
							{
								long roomTimer = Long.parseLong(roomList.get(room).toString());
								vertx.cancelTimer(roomTimer);
								roomList.remove(room);
								socketIdChart.remove(socket.getId());
							}
							
						}
						
						socket.leave(room);
						
					}
				});
				
				/*
				 * 알람 서비스를 위한 입장
				 * */
				socket.on("alarmroomjoin", new Handler<JsonObject>() { 
					public void handle(JsonObject data) {
						String room = data.getString("room");
						socket.join(room);
						socketIdAlarm.put(socket.getId(), room);
						io.sockets().in(room).emit("alarmroomjoinok", "ok");
					}
				});
				
				/*
				 * 알람 서비스를 위한 퇴장
				 * */
				socket.on("alarmroomout", new Handler<JsonObject>() { 
					public void handle(JsonObject data) { 
						String room = data.getString("room");
						if(io.sockets().manager().rooms().get("/"+room).size() == 1)
						{
							if(roomList.get(room) != null)
							{
								long roomTimer = Long.parseLong(roomList.get(room).toString());
								vertx.cancelTimer(roomTimer);
								roomList.remove(room);
								socketIdAlarm.remove(socket.getId());
							}
							
						}
						socket.leave(room);
						
					}
				});
				
				/*
				 * 강제 종료시
				 * */
				socket.onDisconnect(new Handler<JsonObject>() {

					@Override
					public void handle(JsonObject data) {
						if(socketIdMap.get(socket.getId()) != null){
							String mapRoom = socketIdMap.get(socket.getId()).toString();
							if(io.sockets().manager().rooms().get("/"+mapRoom).size() == 1)
							{
								if(roomList.get(mapRoom) != null)
								{
									long roomTimer = Long.parseLong(roomList.get(mapRoom).toString());
									vertx.cancelTimer(roomTimer);
									roomList.remove(mapRoom);
								}
								
								
							}
							socket.leave(mapRoom);
							socketIdMap.remove(socket.getId());
						}
						
						// 소켓 아이디에 가지고 있는 국가지진관측망 방을 다 없애야 함
						
						if(socketIdChart.get(socket.getId()) != null)
						{
							String chartRoom = socketIdChart.get(socket.getId()).toString();
							if(io.sockets().manager().rooms().get("/"+chartRoom).size() == 1)
							{
								if(roomList.get(chartRoom) != null)
								{
									long roomTimer = Long.parseLong(roomList.get(chartRoom).toString());
									vertx.cancelTimer(roomTimer);
									roomList.remove(chartRoom);
								}
								
								
							}
							socket.leave(chartRoom);
							
							socketIdChart.remove(socket.getId());
						}
						
						if(socketIdAlarm.get(socket.getId()) != null){
							String alarmRoom = socketIdAlarm.get(socket.getId()).toString();
							if(io.sockets().manager().rooms().get("/"+alarmRoom).size() == 1)
							{
								if(roomList.get(alarmRoom) != null)
								{
									long roomTimer = Long.parseLong(roomList.get(alarmRoom).toString());
									vertx.cancelTimer(roomTimer);
									roomList.remove(alarmRoom);
								}
								
								
							}
							socket.leave(alarmRoom);
							socketIdAlarm.remove(socket.getId());
						}
						
					} 
				});
				
				/*
				 * 데이터 수신현황 서비스
				 * */
				socket.on("datareceiveddatareq", new Handler<JsonObject>() { 
					public void handle(JsonObject data) {
						final String room = data.getString("room");
						
						if(roomList.get(room) == null)
						{
							timerID = vertx.setPeriodic(1500, new Handler<Long>() {

								@Override
								public void handle(Long aLong) {
									
									try {
										List<List<Object>> results = datareceivedService.receviedTableDatas();
										JsonObject jo = new JsonObject();
										
										if(results.size() != 0)
										{
											
											if(results != null && results.size() != 0)
											{
												ObjectMapper mapper = new ObjectMapper();
												
												String jsonString = mapper.writeValueAsString(results);
												jo.putString("data", jsonString);
												
											}
										}
										
										io.sockets().in(room).emit("datareceiveddatares", jo);
										
									} catch (Exception e) {
										// TODO Auto-generated catch block
										e.printStackTrace();
									}
								}
							});
							
							roomList.put(room, timerID);
						}
					}
				});
				
				/*
				 * 파형 모니터링 지도 서비스
				 * */
				socket.on("wavemapdatareq", new Handler<JsonObject>() { 
					public void handle(JsonObject data) {
						final String room = data.getString("room");
						if(roomList.get(room) == null)
						{
							timerID = vertx.setPeriodic(1500, new Handler<Long>() {

								@Override
								public void handle(Long aLong) {
									try {
										List<WaveMapDataVO> mapdatas = waveService.mapDatas(room);
										JsonObject jo = new JsonObject();
										
										if(mapdatas.size() != 0)
										{
											ObjectMapper mapper = new ObjectMapper();
											String jsonString = mapper.writeValueAsString(mapdatas);
											jo.putString("data", jsonString);
										}
										
										io.sockets().in(room).emit("wavemapdatares", jo);
										
									} catch (Exception e) {
										// TODO Auto-generated catch block
										e.printStackTrace();
									}
								}
							});
							
							roomList.put(room, timerID);
						}
						
					}
				});
				
				
				/*
				 * 파형 모니터링 차트 서비스
				 * */
				socket.on("wavechartalldatareq", new Handler<JsonObject>() { 
					public void handle(JsonObject data) {
						final String room = data.getString("room");
						final String name = data.getString("name");
						
						try {
							List<WaveChartDataVO> datas = waveService.chartDatas(room);
							
							JsonObject jo = new JsonObject();
							
							if(datas.size() != 0)
							{
								ObjectMapper mapper = new ObjectMapper();
								String jsonString = mapper.writeValueAsString(datas);
								jo.putString("data", jsonString);
								jo.putString("staType", room);
								jo.putString("name", name);
							}
							io.sockets().in(room).emit("wavechartalldatares", jo);
							
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				});
				

				/*
				 * 파형 모니터링 차트 서비스
				 * */
				socket.on("wavechartdatareq", new Handler<JsonObject>() { 
					public void handle(JsonObject data) {
						final String room = data.getString("room");
						if(roomList.get(room) == null)
						{
							timerID = vertx.setPeriodic(1500, new Handler<Long>() {

								@Override
								public void handle(Long aLong) {
									try {
										List<WaveChartDataVO> datas = waveService.chartDatas(room);
										
										JsonObject jo = new JsonObject();
										
										if(datas.size() != 0)
										{
											ObjectMapper mapper = new ObjectMapper();
											String jsonString = mapper.writeValueAsString(datas);
											jo.putString("data", jsonString);
											jo.putString("staType", room);
										}
										
										io.sockets().in(room).emit("wavechartdatares", jo);
										
									} catch (Exception e) {
										e.printStackTrace();
									}
								}
							});
							
							roomList.put(room, timerID);
						}
					}
				});
				
				/*
				 * 파형 모니터링 알람 서비스
				 * */
				socket.on("wavealarmdatareq", new Handler<JsonObject>() { 
					public void handle(JsonObject data) {
						final String room = data.getString("room");
						if(roomList.get(room) == null)
						{
							timerID = vertx.setPeriodic(1500, new Handler<Long>() {

								@Override
								public void handle(Long aLong) {
									try {
										List<SelfEventListVO> datas = waveService.alarmDatas();
										
										if(datas.size() != 0){
											JsonObject jo = new JsonObject();
											ObjectMapper mapper = new ObjectMapper();
											String jsonString = mapper.writeValueAsString(datas);
											jo.putString("data", jsonString);
											io.sockets().in(room).emit("wavealarmdatares", jo);
											
											for (SelfEventListVO data : datas) {
												waveService.endAlarm(data.getNo());
											}
											
										}else{
											
										}
										
									} catch (Exception e) {
										e.printStackTrace();
									}
								}
							});
							
							roomList.put(room, timerID);
						}
					}
				});
			}
		});
		
		server.listen(port);
	}
	
	/**
	 *
	 * <pre>
	 * 1. 개요 : result 이 여러개 일때 사용
	 * 2. 처리내용 : result 이 여러개 일때 사용
	 * </pre>
	 *
	 * @Author	: User
	 * @Date	: 2015. 6. 9.
	 * @Method Name : getDataset
	 * @param datasets
	 * @param index
	 * @return
	 */
	protected <T> List<T> getDataset(List<List<Object>> datasets, int index)  throws Exception{
		return (List<T>) datasets.get(index);
	}

}