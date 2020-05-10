<template>
<v-col>
<v-data-table
    :headers="headers"
    :items="players"
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
        <v-dialog v-model="dialog" max-width="500px">
          <template v-slot:activator="{ on }">
            <v-btn color="primary" dark class="mb-2" v-on="on">New Player</v-btn>
          </template>
          <v-card>
         
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>
           
            <v-card-text>
             <v-form
                ref="form"
            v-model="valid"
                >
              <v-container>
                <v-row>
                  <v-col cols="12" sm="12" md=12>
                    <v-select

                                  item-text="name"
                                  item-value="id"
                                  v-model="editedItem.teamid"
                                  :items="teams"
                                  label="Select Team"
                                  ></v-select>
                   </v-col>
                  <v-col cols="12" sm="12" md=12>
                    <v-text-field v-model="editedItem.firstName" label="First Name" name="firstname" required :rules="FirstNameRules"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="12" md=12>
                    <v-text-field v-model="editedItem.lastName" label="Last Name" name="lastname" required :rules="LastNameRules"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="12" md="12">
                    <v-file-input accept="image/png, image/jpeg, image/bmp"  v-model="logoUri" label="Logo" name="logoUri"></v-file-input>
                    <input type="hidden" name="old_image" id="old_image" v-model="editedItem.imageUri"/>
                  </v-col>
                  <v-col cols="12" sm="12" md=12 v-if="editedIndex!=-1">
                  
                  <div class="p-2" >
                  <v-img :src="'../storage/'+editedItem.imageUri" :alt="editedItem.firstName" width="50px" height="50px"></v-img>
                </div>
                </v-col>

                  <v-col cols="12" sm="12" md=12>
                    <v-text-field v-model="editedItem.Playerjerseynumber" label="Player Jersey Number" name="Playerjerseynumber" required :rules="JRules"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="12" md="12">
                    <v-text-field v-model="editedItem.country" :rules="CRules" label="Country" name="clubstate" required></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="12" md="12">
                    <v-text-field v-model="editedItem.matches" :rules="MRules" label="Player Matches" name="clubstate" required></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="12" md="12">
                    <v-text-field v-model="editedItem.run"  label="Player Total Run" name="clubstate" required></v-text-field>
                  </v-col>

                    <v-col cols="12" sm="12" md="12">
                    <v-text-field v-model="editedItem.highestscores "  label="Player Highest Scores " name="clubstate" required></v-text-field>
                  </v-col>


                  <v-col cols="12" sm="12" md=12>
                    <v-text-field v-model="editedItem.fifties" label="Player Fifties" name="Playerjerseynumber" required ></v-text-field>
                  </v-col>
                   <v-col cols="12" sm="12" md=12>
                    <v-text-field v-model="editedItem.hundreds" label="Player Hundreds" name="Playerjerseynumber" required ></v-text-field>
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
    <template v-slot:item.imageUri="{ item }">
            <div class="p-2">
              <v-img :src="'../storage/'+item.imageUri" :alt="item.firstName" width="50px" height="50px"></v-img>
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
          
          old_image:'',
           FirstNameRules: [
           v => !!v || 'First name is required'
         ],
         LastNameRules: [
           v => !!v || 'Last name is required'
         ],
         JRules: [
           v => !!v || 'Player jersey number is required'
         ],
         CRules: [
           v => !!v || 'Country is required'
         ],
          MRules: [
           v => !!v || 'Matches is required'
         ],
         
         LogoRules:[v=>!!V || 'Team logo is required'],
         input: {
            user_id: 2,
        },
        hselect: { name: 'Delhi Capitals' },
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
        { text: 'Team', value: 'teamName' },
        { text: 'First Name', value: 'firstName' },
        { text: 'Last Name', value: 'lastName' },
        { text: 'Photo', value: 'imageUri' },
        { text: 'Jursey Number', value: 'Playerjerseynumber' },
        { text: 'Country', value: 'country' },
         { text: 'Matches', value: 'matches' },
         { text: 'Run', value: 'run' },
         { text: 'Highest Scores', value: 'highestscores' },
         { text: '50s', value: 'fifties' },
         { text: '100s', value: 'hundreds' },
        { text: 'Actions', value: 'actions', sortable: false },
      ],
      players: [],
      teams:[],
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
        return this.editedIndex === -1 ? 'Add Player' : 'Edit Player'
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
        
       	axios.get('/api/players/getplayer').
       	then(res=>{
       	  
       	 this.players=res.data.players; 
         this.teams=res.data.teams;
       	 	}).catch(err=>console.dir(err));
      },

      editItem (item) {

        this.editedIndex = item.id
        this.editedItem = Object.assign({}, item)
        this.dialog = true
      },

      deleteItem (item) {
        const index = this.players.indexOf(item);
        
        var con=confirm('Are you sure you want to delete this item?')

        if(con)
        {
        axios.get('/api/players/delete/'+item.id).
        then(res=>{
         this.players.splice(index,1); 
         this.players=res.data.teams;
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
           formdata.append('team_id',this.editedItem.teamid);
           formdata.append('firstname',this.editedItem.firstName);
           formdata.append('lastname',this.editedItem.lastName);
           formdata.append('playerjerseynumber',this.editedItem.Playerjerseynumber);
           formdata.append('country',this.editedItem.country);
           formdata.append('matches',this.editedItem.matches);
           formdata.append('run',this.editedItem.run);
           formdata.append('highestscores',this.editedItem.highestscores);
           formdata.append('fifties',this.editedItem.fifties);
           formdata.append('hundreds',this.editedItem.hundreds);
      
            axios.post('/api/players/updateplayer',formdata).
           then(res=>{
          
         //this.players=res.data.teams; 
         this.msg="Record updated successfully";
         this.snackbar=true;
         this.initialize();
         
        }).catch(err=>{

        
         this.msg="Error in Inserting Records";
         this.snackbar=true;

        });


        } else {
          
          if(this.logoUri!=null){
          var formdata= new FormData();
           formdata.append('photo',this.logoUri,this.logoUri.name);
           formdata.append('team_id',this.editedItem.teamid);
           formdata.append('firstname',this.editedItem.firstName);
           formdata.append('lastname',this.editedItem.lastName);
           formdata.append('playerjerseynumber',this.editedItem.Playerjerseynumber);
           formdata.append('country',this.editedItem.country);
           formdata.append('matches',this.editedItem.matches);
           formdata.append('run',this.editedItem.run);
           formdata.append('highestscores',this.editedItem.highestscores);
           formdata.append('fifties',this.editedItem.fifties);
           formdata.append('hundreds',this.editedItem.hundreds);
           
            axios.post('/api/players/addplayer',formdata).
           then(res=>{
          
         this.players=res.data.teams; 
         this.msg="Record added successfully";
         this.snackbar=true;
          this.initialize();
         
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