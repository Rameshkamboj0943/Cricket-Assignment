<template>
<v-app id="inspire">
    <v-navigation-drawer
      v-model="drawer"
      app
      clipped
    >
      <v-list dense>
        <v-list-item
          v-for="item in items"
          :key="item.text"
          link
          :to="item.action"
        >
          <v-list-item-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>
              {{ item.text }}
            </v-list-item-title>
          </v-list-item-content>
        </v-list-item>
         </v-list>
    </v-navigation-drawer>

    <v-app-bar
      app
      clipped-left
      color="red"
      dense
    >
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      
      <v-toolbar-title class="mr-12 align-center">
        <span class="title">Cricket Assignment</span>
      </v-toolbar-title>
      <v-spacer />
      <v-row
        align="center"
        style="max-width: 650px"
      >
        <v-text-field
          :append-icon-cb="() => {}"
          placeholder="Search..."
          single-line
          append-icon="mdi-magnify"
          color="white"
          hide-details
        />
      </v-row>
    </v-app-bar>

    <v-content>    
   <v-data-table
    :headers="headers"
    :items="teams"
    sort-by="calories"
    class="elevation-1"
  >
  <v-progress-linear
             :active="loading"
              :indeterminate="loading"
              absolute
             bottom
             color="deep-purple accent-4">
             </v-progress-linear>
    <template v-slot:top>
      <v-toolbar flat color="white">
        <v-toolbar-title>Team List</v-toolbar-title>
        <v-divider
          class="mx-4"
          inset
          vertical
        ></v-divider>
        <v-spacer></v-spacer>
        
      </v-toolbar>
    </template>
    <template v-slot:item.logoUri="{ item }">
            <div class="p-2">
              <a :href="'#/home/player/' + item.id"><v-img :src="'../storage/'+item.logoUri" :id="item.id" :alt="item.name" width="50px" height="50px"></v-img></a>
            </div>
          </template>
     

  </v-data-table>
 <router-view></router-view>
     
    </v-content>
  </v-app>

</template>
<script>
export default {
    data: () => ({
    drawer: null,
      items: [
        { icon: 'mdi-trending-up', action:'/',text: 'Team List' },
        { icon: 'mdi-history', action:'/home/match',text: 'Match List' },
        { icon: 'mdi-playlist-play',action:'/home/points', text: 'Points' },
         ],
          valid: true,
          name: '',
          old_image:'',
          TeamNameRules: [
           v => !!v || 'Team name is required'
         ],
         clubstate:'',
         ClubRules: [
           v => !!v || 'Club state is required'
         ],
         LogoRules:[v=>!!V || 'Team logo is required'],

      loading:false,
      dialog: false,
      snackbar: false,
      msg:'',
      color: '',
      mode: '',     
        timeout: 6000,
        x: null,
        y: 'top',
      headers: [
        { text: 'Team Logo', value: 'logoUri' },
        
        { text: 'Team Name', value: 'name' },
        ],
      teams: [],
      logoUri:null,
      editedIndex: -1,
      editedItem: {
        id: '',
        name: '',
        logoUri:null,
        clubstate:'',

      
      },
      defaultItem: {
        id: '',
        name: '',
        logoUri: null,
        clubstate: '',
        
      },
    }),

    computed: {
      formTitle () {
        return this.editedIndex === -1 ? 'Add Teams' : 'Edit Teams'
      },
    },

    watch: {
      dialog (val) {
        val || this.close()
      },
    },

    created () {
      this.initialize()
    },

    methods: {
      initialize () {
       axios.interceptors.request.use((config)=>{
        this.loading=true;
        return config;
        },
        (error)=>{
        this.loading=false;
        return Promise.reject(error);
       });

    axios.interceptors.response.use((config)=>{
        this.loading=false;
        return config;
        },
        (error)=>{
          this.loading=false;
        return Promise.reject(error);
       });
        
        axios.get('/api/teams').
        then(res=>{
          
         this.teams=res.data.teams; 
         
        }).catch(err=>console.dir(err));
      },
      viewPlayer (item){
      alert(item.id);
      },
      editItem (item) {
      
        this.editedIndex = item.id
        this.editedItem = Object.assign({}, item)
        this.dialog = true
      },

      deleteItem (item) {
        const index = this.teams.indexOf(item);
        
        var con=confirm('Are you sure you want to delete this item?')

        if(con)
        {
        axios.delete('/api/teams/'+item.id).
        then(res=>{
         this.teams.splice(index,1); 
         this.teams=res.data.teams;
         this.msg="Record deleted successfully";
         this.snackbar=true;
         
        }).catch(err=>console.dir(err));

        }
      },

      close () {
        this.dialog = false
        setTimeout(() => {
          this.editedItem = Object.assign({}, this.defaultItem)
          this.editedIndex = -1
        }, 300)
      },

      save () {
        if (this.editedIndex > -1) {
          var formdata= new FormData();
          if(this.logoUri!=null){
           
        
           formdata.append('photo',this.logoUri,this.logoUri.name);
           }else
           {
            formdata.append('photo',$('#old_image').val());
          
           }
            formdata.append('id',this.editedIndex);
           formdata.append('name',this.editedItem.name);
           formdata.append('clubstate',this.editedItem.clubstate);
            axios.post('/api/teams/update',formdata).
           then(res=>{
          
         this.teams=res.data.teams; 
         this.msg="Record added successfully";
         this.snackbar=true;
         
        }).catch(err=>console.dir(err));


        } else {
        
          if(this.logoUri!=null){
          var formdata= new FormData();
          
           formdata.append('photo',this.logoUri,this.logoUri.name);
           formdata.append('name',this.editedItem.name);
           formdata.append('clubstate',this.editedItem.clubstate);
            axios.post('/api/teams/addteam',formdata).
           then(res=>{
          
         this.teams=res.data.teams; 
         this.msg="Record added successfully";
         this.snackbar=true;
         
        }).catch(err=>console.dir(err));
      }


          //this.users.push(this.editedItem)
        }
        this.close()
      },
    },
  }
</script>
<style scoped></style>