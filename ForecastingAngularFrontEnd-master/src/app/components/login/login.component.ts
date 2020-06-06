import { Component, OnInit } from '@angular/core';
import { DataService } from '../../service/data.service'

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  user : {username, password} = {username: "", password: ""};
  constructor(private dataService: DataService) { }

  ngOnInit() {
  }

  validateUser() {
    console.log(this.user)
    this.dataService.validateUsers(this.user).subscribe((res) => {
    });
  }
}
