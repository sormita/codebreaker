import { Component, OnInit } from '@angular/core';
import { DataService } from '../../service/data.service';
import { figures } from '../../classes/figures'

@Component({
  selector: 'app-upload',
  templateUrl: './upload.component.html',
  styleUrls: ['./upload.component.css']
})
export class UploadComponent implements OnInit {

  fileToUpload: File = null;

  totalCount: figures = new figures()
  countryCount: figures = new figures()

  constructor(private dataService: DataService) { }

  ngOnInit() {
    this.dataService.getData()
      .subscribe(
        data => {
          this.totalCount = data['Global'];
          this.countryCount = data['Countries'][76];
          console.log(this.totalCount)
          console.log(this.countryCount)
        }
      );
  }

  handleFileInput(files: FileList) {
    this.fileToUpload = files.item(0);
    console.log(this.fileToUpload)
    this.uploadFileToActivity();
  }

  uploadFileToActivity() {
    this.dataService.postFile(this.fileToUpload).subscribe(data => {
      // do something, if upload success
    }, error => {
      console.log(error);
    });
  }
}
