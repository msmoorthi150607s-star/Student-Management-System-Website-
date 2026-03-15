package com.adminModel;

public class Fees {

    private int    feeId;
    private String rollNumber;
    private double amount;
    private String status;   // PAID or PENDING
    private String dueDate;

    // ── Default Constructor ──
    public Fees() {}

    // ── Parameterized Constructor ──
    public Fees(int feeId, String rollNumber,
                double amount, String status, String dueDate) {
        this.feeId      = feeId;
        this.rollNumber = rollNumber;
        this.amount     = amount;
        this.status     = status;
        this.dueDate    = dueDate;
    }

    // ── Getters ──
    public int    getFeeId()      { return feeId;      }
    public String getRollNumber() { return rollNumber; }
    public double getAmount()     { return amount;     }
    public String getStatus()     { return status;     }
    public String getDueDate()    { return dueDate;    }

    // ── Setters ──
    public void setFeeId(int feeId)           { this.feeId      = feeId;      }
    public void setRollNumber(String roll)    { this.rollNumber = roll;       }
    public void setAmount(double amount)      { this.amount     = amount;     }
    public void setStatus(String status)      { this.status     = status;     }
    public void setDueDate(String dueDate)    { this.dueDate    = dueDate;    }
}