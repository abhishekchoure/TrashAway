package data;

public class Request {
	private Industry industry;
	private String status;

	public Request(Industry industry, String status) {
		super();
		this.industry = industry;
		this.status = status;
	}
	
	public Industry getIndustry() {
		return industry;
	}
	public void setIndustry(Industry industry) {
		this.industry = industry;
	}
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
}
