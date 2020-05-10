import Vue from 'vue';
import VueRouter from 'vue-router';
import LoginComponent from './components/LoginComponent';
import Admincomponent from './components/Admincomponent';
import Homecomponent from './components/Homecomponent';
import MatchListComponent from './components/MatchListcomponent';
import PointListComponent from './components/PointListcomponent';
import PlayerListComponent from './components/PlayerListcomponent';
import UserComponent from './components/UserComponent';
import TeamComponent from './components/TeamComponent';
import PlayerComponent from './components/PlayerComponent';
import MatchComponent from './components/MatchComponent';
import PointComponent from './components/PointComponent';
//const user ={template:"<v-alert type='info'>Hi {{$route.params.name}}</v-alert>"}

Vue.use(VueRouter);
const routes=[
{
  path:'/',
  //redirect:'/login'
  component:Homecomponent,
  name:'Home',
  children:[
  
   { 
    path:'/home/match',
    component:MatchListComponent,
  },
  { 
    path:'/home/points',
    component:PointListComponent,
  },
  { 
    path:'/home/player/:id',
    component:PlayerListComponent,
  },
   ],
},
{
  path:'/login',
  component:LoginComponent,
  name:'Login',
},
{
path:'/admin',
  component:Admincomponent,
  name:'Admin',
  children:[
  {
  	path:'/admin/users',
  	component:UserComponent,
  },
  {
    path:'/admin/teams',
    component:TeamComponent,
    name:'Teams',
  },
  {
    path:'/admin/players',
    component:PlayerComponent,
    name:'Players',
  },
  {
    path:'/admin/matches',
    component:MatchComponent,
    name:'Match Fixtures',
  },
  {
    path:'/admin/points',
    component:PointComponent,
    name:'Match Points',
  },
  ],

  beforeEnter: (to, from, next) => {
        if(localStorage.getItem('token'))
        {
          next();
        }else
        {
        	next('/');
        }
      }
  
}
];

export default new VueRouter({routes})