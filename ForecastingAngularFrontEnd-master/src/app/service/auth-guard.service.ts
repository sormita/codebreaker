import { Injectable } from '@angular/core';
import { CanActivate, Router, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { DataService } from './data.service';

@Injectable()
export class AuthGuardService implements CanActivate {

  constructor(private dataService: DataService, private router: Router) {}
  
  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    if (this.dataService.isUserLogged()) {
      return true;
    } else {
      this.router.navigateByUrl('/error');
      return false;
    }
  }
}

