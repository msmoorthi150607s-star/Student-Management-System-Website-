package com.adminModel;

public class Staff {

    private int    staffId;
    private String staffName;
    private String role;        // Teaching or Clerical
    private String department;
    private int    age;
    private double salary;
    private int    attendance;

    // ── Default Constructor ──
    public Staff() {}

    // ── Parameterized Constructor ──
    public Staff(int staffId, String staffName, String role,
                 String department, int age,
                 double salary, int attendance) {
        this.staffId    = staffId;
        this.staffName  = staffName;
        this.role       = role;
        this.department = department;
        this.age        = age;
        this.salary     = salary;
        this.attendance = attendance;
    }

    // ── Getters ──
    public int    getStaffId()    { return staffId;    }
    public String getStaffName()  { return staffName;  }
    public String getRole()       { return role;       }
    public String getDepartment() { return department; }
    public int    getAge()        { return age;        }
    public double getSalary()     { return salary;     }
    public int    getAttendance() { return attendance; }

    // ── Setters ──
    public void setStaffId(int staffId)        { this.staffId    = staffId;    }
    public void setStaffName(String staffName) { this.staffName  = staffName;  }
    public void setRole(String role)           { this.role       = role;       }
    public void setDepartment(String dept)     { this.department = dept;       }
    public void setAge(int age)                { this.age        = age;        }
    public void setSalary(double salary)       { this.salary     = salary;     }
    public void setAttendance(int attendance)  { this.attendance = attendance; }
}