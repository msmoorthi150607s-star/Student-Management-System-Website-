package com.studentModel;

public class Student {
    private String rollNumber;
    private String studentName;
    private int    age;
    private String grade;
    private String section;
    private double fees;
    private String address;
    private String parentName;
    private String contactNumber;
    private String createdAt;

    // ── Constructors ──
    public Student() {}

    public Student(String rollNumber, String studentName, int age,
                   String grade, String section, double fees,
                   String address, String parentName,
                   String contactNumber, String createdAt) {
        this.rollNumber    = rollNumber;
        this.studentName   = studentName;
        this.age           = age;
        this.grade         = grade;
        this.section       = section;
        this.fees          = fees;
        this.address       = address;
        this.parentName    = parentName;
        this.contactNumber = contactNumber;
        this.createdAt     = createdAt;
    }

    // ── Getters ──
    public String getRollNumber()    { return rollNumber;    }
    public String getStudentName()   { return studentName;   }
    public int    getAge()           { return age;           }
    public String getGrade()         { return grade;         }
    public String getSection()       { return section;       }
    public double getFees()          { return fees;          }
    public String getAddress()       { return address;       }
    public String getParentName()    { return parentName;    }
    public String getContactNumber() { return contactNumber; }
    public String getCreatedAt()     { return createdAt;     }

    // ── Setters ──
    public void setRollNumber(String rollNumber)       { this.rollNumber    = rollNumber;    }
    public void setStudentName(String studentName)     { this.studentName   = studentName;   }
    public void setAge(int age)                        { this.age           = age;           }
    public void setGrade(String grade)                 { this.grade         = grade;         }
    public void setSection(String section)             { this.section       = section;       }
    public void setFees(double fees)                   { this.fees          = fees;          }
    public void setAddress(String address)             { this.address       = address;       }
    public void setParentName(String parentName)       { this.parentName    = parentName;    }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }
    public void setCreatedAt(String createdAt)         { this.createdAt     = createdAt;     }
}