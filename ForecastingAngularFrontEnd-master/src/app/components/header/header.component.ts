import { Component, OnInit } from '@angular/core';
import { DataService } from '../../service/data.service'

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {

  constructor(public service: DataService) { }

  ngOnInit() {

  }

  logout() {
    this.service.isLoggedIn = false;
    this.service.isAdmin = false;
  }
}
