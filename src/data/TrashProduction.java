package data;

import java.util.LinkedList;

public class TrashProduction {
	private LinkedList<Trash> trashProduced;
	private double totalQuantity;
	private double totalPrice;
	
	public TrashProduction() {}
	
	public double getTotalQuantity() {
		return totalQuantity;
	}
	public void setTotalQuantity(double totalQuantity) {
		this.totalQuantity = totalQuantity;
	}
	public double getTotalPrice() {
		return totalPrice;
	}
	public void setTotalPrice(double totalPrice) {
		this.totalPrice = totalPrice;
	}
}
