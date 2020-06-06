import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { map, catchError } from 'rxjs/operators';
import { Users } from '../classes/users';
import { Router } from '@angular/router';
import Swal from 'sweetalert2';

@Injectable({
  providedIn: 'root'
})

export class DataService {

  public isLoggedIn: boolean = false;
  public isAdmin = false;

  constructor(private http: HttpClient, private router: Router) { }

  /* Get COVID-19 figures */
  getData(): Observable<any> {
    return this.http.get('https://withackfunctions.azurewebsites.net/api/CovidSummary')
  }

  /* Registration */
  createUsers(user: Users[]) {
    return this.http.post('https://withackfunctions.azurewebsites.net/api/UserRegistration', user).
      pipe(
        map((data: any) => {
          console.log("Success:", user)
          Swal.fire("Success!", "Registered Successfully!", "success");    /* alert */
          this.router.navigate(['/login']);
          return data;
        }), catchError(error => {
          this.router.navigate(['/error']);
          return throwError('Something went wrong!');
        })
      )
  }

  /* Login */
  validateUsers(user) {
    return this.http.get('https://withackfunctions.azurewebsites.net/api/UserLogin/' + user.username + '/' + user.password).
      pipe(
        map((data: any) => {
          Swal.fire("Success!", "Logged in Successfully!", "success");      /* alert */
          this.isLoggedIn = true;
          if (user.username == 'admin@gmail.com') {
            this.isAdmin = true;
            this.router.navigate(['/upload']);
          }
          else
            this.router.navigate(['/upload']);
          return data;
        }), catchError(error => {
          this.router.navigate(['/error']);
          return throwError('Something went wrong!');
        })
      )
  }

  /* Check if user logged in*/
  isUserLogged() {
    return this.isLoggedIn;
  }

  /* Check if admin*/
  checkUser() {
    return this.isAdmin;
  }

  /* Upload File */
  postFile(fileToUpload: File): Observable<boolean> {
    const endpoint = 'https://withackfunctions.azurewebsites.net/api/BlobUpload';
    const formData: FormData = new FormData();

    formData.append('fileKey', fileToUpload, fileToUpload.name);
    return this.http
      .post(endpoint, formData).
      pipe(
        map((data: any) => {
          Swal.fire("Success!", "Data Upload Successful!", "success");      /* alert */
          // this.router.navigate(['/upload']);
          return data;
        }), catchError(error => {
          this.router.navigate(['/error']);
          return throwError('Something went wrong!');
        })
      )
  }
}

