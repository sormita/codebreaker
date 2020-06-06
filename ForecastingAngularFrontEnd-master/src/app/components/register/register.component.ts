import { Component, OnInit } from '@angular/core';
import { DataService } from '../../service/data.service';
import * as $ from 'jquery';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {

  user: any = {};

  constructor(public dataService: DataService) { }

  ngOnInit() {
    $("#entityType").change(function () {
      var correspondingID = $(this).val()
      $(".style-sub-1").hide();
      $("#" + correspondingID).show();
    })
  }

  createUser() {
    console.log(this.user)
    this.dataService.createUsers(this.user).subscribe((res) => {
    });
  }
}

