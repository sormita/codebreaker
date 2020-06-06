import { Component, OnInit } from '@angular/core';
import { DataService } from '../../service/data.service'
import { figures } from '../../classes/figures'

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})

export class HomeComponent implements OnInit {

  constructor() { }

  ngOnInit() {

    window['watsonAssistantChatOptions'] = {
      integrationID: "3a86a8f4-6947-4a0b-a746-1d6c94d85b46", // The ID of this integration.
      region: "us-south", // The region your integration is hosted in.
      serviceInstanceID: "50cf4bbe-a160-4b6d-8944-a4f9234c4a1b", // The ID of your service instance.
      onLoad: function (instance) { instance.render(); }
    }
  }
  setTimeout() {
    const t = document.createElement('script');
    t.src = "https://web-chat.global.assistant.watson.appdomain.cloud/loadWatsonAssistantChat.js";
    document.head.appendChild(t);
  };
}