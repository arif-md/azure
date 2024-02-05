package com.emerald.demo;

import static org.hamcrest.CoreMatchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(ApiController.class)
public class ApiControllerTest {

    @Autowired
    private MockMvc mvc;
    
	@Test
	void greetingShouldReturnDefaultMessage() throws Exception {
		mvc.perform(get("/api/hello")
		 .contentType(MediaType.APPLICATION_JSON))
		 .andExpect(status().isOk())
		 .andExpect(jsonPath("$", is("hello azure Java Web app!")));
	}	
	
}
