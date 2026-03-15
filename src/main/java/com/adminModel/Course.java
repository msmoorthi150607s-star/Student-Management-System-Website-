package com.adminModel;

public class Course {

    private String courseId;
    private String courseName;
    private String courseDescription;
    private double courseFee;

    // ── Default Constructor ──
    public Course() {}

    // ── Parameterized Constructor ──
    public Course(String courseId, String courseName,
                  String courseDescription, double courseFee) {
        this.courseId          = courseId;
        this.courseName        = courseName;
        this.courseDescription = courseDescription;
        this.courseFee         = courseFee;
    }

    // ── Getters ──
    public String getCourseId()          { return courseId;          }
    public String getCourseName()        { return courseName;        }
    public String getCourseDescription() { return courseDescription; }
    public double getCourseFee()         { return courseFee;         }

    // ── Setters ──
    public void setCourseId(String courseId)                   { this.courseId          = courseId;          }
    public void setCourseName(String courseName)               { this.courseName        = courseName;        }
    public void setCourseDescription(String courseDescription) { this.courseDescription = courseDescription; }
    public void setCourseFee(double courseFee)                 { this.courseFee         = courseFee;         }
}