package com.example.taskapi.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import com.example.taskapi.model.Task;

import java.util.List;
import java.util.Arrays;

@RestController
public class TaskController {

    @GetMapping("/api/tasks")
    public List<Task> getTasks() {
        return List.of(
            new Task("1", "Deploy EKS Cluster", true),
            new Task("2", "Build Spring Boot API", true),
            new Task("3", "Dockerize the app", false),
            new Task("4", "Deploy to Kubernetes", false)
        );
    }
}
