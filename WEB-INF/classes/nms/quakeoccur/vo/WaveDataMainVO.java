package nms.quakeoccur.vo;

import java.util.List;

public class WaveDataMainVO {
	private String sta;
	private String chan;
	private String net;
	private String loc;
	private int sampleRate;
	private List<WaveDataSubVO> data;
	public String getSta() {
		return sta;
	}
	public void setSta(String sta) {
		this.sta = sta;
	}
	public String getChan() {
		return chan;
	}
	public void setChan(String chan) {
		this.chan = chan;
	}
	public String getNet() {
		return net;
	}
	public void setNet(String net) {
		this.net = net;
	}
	public String getLoc() {
		return loc;
	}
	public void setLoc(String loc) {
		this.loc = loc;
	}
	public int getSampleRate() {
		return sampleRate;
	}
	public void setSampleRate(int sampleRate) {
		this.sampleRate = sampleRate;
	}
	public List<WaveDataSubVO> getData() {
		return data;
	}
	public void setData(List<WaveDataSubVO> data) {
		this.data = data;
	}

	
}
