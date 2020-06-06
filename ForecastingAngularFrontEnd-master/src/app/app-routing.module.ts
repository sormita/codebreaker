import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './components/home/home.component';
import { RegisterComponent } from './components/register/register.component';
import { LoginComponent } from './components/login/login.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { UploadComponent } from './components/upload/upload.component';
import { ErrorPageComponent } from './components/error-page/error-page.component';
import { AuthGuardService } from './service/auth-guard.service';
import { LogoutComponent } from './components/logout/logout.component';

const routes: Routes = [
  { path: "", pathMatch: "full", redirectTo: "home" },
  { path: "home", component: HomeComponent },
  { path: "register", component: RegisterComponent },
  { path: "login", component: LoginComponent },
  { path: "upload", component: UploadComponent, canActivate: [AuthGuardService] },
  { path: "dashboard", component: DashboardComponent, canActivate: [AuthGuardService] },
  { path: "error", component: ErrorPageComponent },
  { path: "logout", component: LogoutComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
