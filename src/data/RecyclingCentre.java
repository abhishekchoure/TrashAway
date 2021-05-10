package data;

import java.util.Hashtable;

public class RecyclingCentre {
	private String name;
	private String email;
	private String address;
	private String city;
	private int pincode;
	private Hashtable<Dealer,Industry> source;
	private Report report;

	public RecyclingCentre(String name, String email, String address, String city, int pincode) {
		super();
		this.name = name;
		this.email = email;
		this.address = address;
		this.city = city;
		this.pincode = pincode;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public int getPincode() {
		return pincode;
	}
	public void setPincode(int pincode) {
		this.pincode = pincode;
	}
}
