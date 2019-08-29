package nms.quakeoccur.vo;

import java.util.List;

public class WaveDataSubVO {
	private String time;
	private int nSamples;
	private int[] values;
	
	public int getnSamples() {
		return nSamples;
	}
	public void setnSamples(int nSamples) {
		this.nSamples = nSamples;
	}
	public int[] getValues() {
		return values;
	}
	public void setValues(int[] values) {
		this.values = values;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	
	
}
