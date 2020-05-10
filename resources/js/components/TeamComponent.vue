<template>
<v-col>
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
        <v-toolbar-title>My CRUD</v-toolbar-title>
        <v-divider
          class="mx-4"
          inset
          vertical
        ></v-divider>
        <v-spacer></v-spacer>
        <v-dialog v-model="dialog" max-width="500px">
          <template v-slot:activator="{ on }">
            <v-btn color="primary" dark class="mb-2" v-on="on">New Team</v-btn>
          </template>
          <v-card>
         
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>
            <v-snackbar
              v-model="snackbar"
              :bottom="y === 'bottom'"
              :color="color"
              :left="x === 'left'"
              :multi-line="mode === 'multi-line'"
              :right="x === 'right'"
              :timeout="timeout"
              :top="y === 'top'"
              :vertical="mode === 'vertical'"
            >
              {{ msg }}
              <v-btn
                dark
                text
                @click="snackbar = false"
              >
                Close
              </v-btn>
            </v-snackbar>
            <v-card-text>
             <v-form
                ref="form"
            v-model="valid"
                >
              <v-container>
                <v-row>
                  <v-col cols="12" sm="12" md=12>
                    <v-text-field v-model="editedItem.name" label="Team Name" name="teamname" required :rules="TeamNameRules"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="12" md="12">
                    <v-file-input accept="image/png, image/jpeg, image/bmp"  v-model="logoUri" label="Logo" name="logoUri"></v-file-input>
                    <input type="hidden" name="old_image" id="old_image" v-model="editedItem.logoUri"/>
                  </v-col>
                  <div class="p-2" v-if="editedIndex!=-1">
                  <v-img :src="'../storage/'+editedItem.logoUri" :alt="editedItem.name" width="50px" height="50px"></v-img>
                </div>
                  <v-col cols="12" sm="12" md="12">
                    <v-text-field v-model="editedItem.clubstate" :rules="ClubRules" label="Club State" name="clubstate" required></v-text-field>
                  </v-col>
                  
                </v-row>
              </v-container>
               </v-form>
            </v-card-text>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="close">Cancel</v-btn>
              <v-btn color="blue darken-1" :disabled="!valid" text @click="save">Save</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>
    </template>
    <template v-slot:item.logoUri="{ item }">
            <div class="p-2">
              <v-img :src="'../storage/'+item.logoUri" :alt="item.name" width="50px" height="50px"></v-img>
            </div>
          </template>
    <template v-slot:item.actions="{ item }">
      <v-icon
        small
        class="mr-2"
        @click="editItem(item)"
      >
        mdi-pencil
      </v-icon>
      <v-icon
        small
        @click="deleteItem(item)"
      >
        mdi-delete
      </v-icon>
    </template>
    <template v-slot:no-data>
      <v-btn color="primary" @click="initialize">Reset</v-btn>
    </template>

  </v-data-table>
  </v-col>
</template>
<script>
export default {
    data: () => ({
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
        {
          text: '#',
          align: 'start',
          sortable: false,
          value: 'id',
        },
        { text: 'Name', value: 'name' },
        { text: 'TeamLogo', value: 'logoUri' },
        { text: 'State', value: 'clubstate' },
       
        { text: 'Actions', value: 'actions', sortable: false },
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