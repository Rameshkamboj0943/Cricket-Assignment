<template>
<v-col>
<v-data-table
    :headers="headers"
    :items="matches"
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
            <v-btn color="primary" dark class="mb-2" v-on="on">New Match</v-btn>
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
                                  v-model="editedItem.teamA"
                                  :items="teams"
                                  label="Team A"
                                  ></v-select>

                            

                        
                     </v-col>
                  <v-col cols="12" sm="12" md=12>
                                          
                              <v-select

                                  item-text="name"
                                  item-value="id"
                                  v-model="editedItem.teamB"
                                  :items="teams"
                                  label="Team B"
                                 
                                  ></v-select>

                            

                        
                    </v-col>
                  
                 
      <v-col cols="12" sm="6" md="12">
      <v-menu
        v-model="menu2"
        :close-on-content-click="false"
        :nudge-right="40"
        transition="scale-transition"
        offset-y
        min-width="290px"
      >
        <template v-slot:activator="{ on }">
          <v-text-field
            v-model="editedItem.matchdate"
            label="Match Date"
            prepend-icon=""
            readonly
            v-on="on"
          ></v-text-field>
        </template>
        <v-date-picker v-model="editedItem.matchdate" @input="menu2 = false"></v-date-picker>
      </v-menu>
    </v-col>
    <v-col cols="12" sm="12" md=12>
                    <v-text-field v-model="editedItem.location" label="Match Location" name="location" required ></v-text-field>
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
      <v-dialog
      v-model="matchdialog"
      max-width="500"
    >
      <v-card>
       <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>
         <v-col cols="12" sm="12" md=12>
         <template>
  <v-container fluid>
    <p>Winner of the Match</p>
    <v-radio-group v-model="radios" :mandatory="false">
      <v-radio :name="editedItem.teamA"  :value="editedItem.teamAID" :label="editedItem.teamA"></v-radio>
      <v-radio :name="editedItem.teamB" :value="editedItem.teamBID" :label="editedItem.teamB"></v-radio>
    </v-radio-group>
       
      </v-container>
</template>
            
  </v-col>
   <v-col cols="12" sm="12" md=12>
         <template>
  <v-container fluid>
    <p>Match Status</p>
    <v-radio-group v-model="status" :mandatory="false">
      <v-radio   value="1" label="Completed"></v-radio>
      <v-radio  value="0" label="Running"></v-radio>
    </v-radio-group>
       
      </v-container>
</template>
            
  </v-col>
                  <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="close">Cancel</v-btn>
              <v-btn color="blue darken-1"  text @click="savematch">Save</v-btn>
            </v-card-actions>
      </v-card>
    </v-dialog>
    </template>
    <template v-slot:item.teamALogo="{ item }">
            <div class="p-2">
              <v-img :src="'../storage/'+item.teamALogo" :alt="item.teamA" width="50px" height="50px"></v-img>
            </div>
          </template>
           <template v-slot:item.teamBLogo="{ item }">
            <div class="p-2">
              <v-img :src="'../storage/'+item.teamBLogo" :alt="item.teamB" width="50px" height="50px"></v-img>
            </div>
          </template>
    <template v-slot:item.actions="{ item }">
      <v-icon
        small
        class="mr-2"
        @click="editItem(item)"
        v-if="item.completed==0"
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
          radios:'',
          status:'',
          date: new Date().toISOString().substr(0, 10),
          modal: false,
          menu2: false,
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
         
      loading:false,
      dialog: false,
      matchdialog:false,
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
        { text: 'Team A Logo', value: 'teamALogo' },
        { text: 'Team A', value: 'teamA' },
        { text: 'Team A', value: 'teamAID' },
        { text: 'Team B Logo', value: 'teamBLogo' },
        { text: 'Team B', value: 'teamB' },
        { text: 'Team B', value: 'teamBID' },
        { text: 'Date Time', value: 'matchdate' },
        { text: 'Location', value: 'location' },
        { text: 'Actions', value: 'actions', sortable: false },
      ],
      teams:[],
      matches: [],
      editedIndex: -1,
      editedItem: {
        id: '',
        teamA: '',
        teamB: '',
        date:'',
        location:'',
      },
      defaultItem: {
        id: '',
        teamA: '',
        teamB: '',
        date:'',
        location:'',
           
      },
    }),

    computed: {
      formTitle () {
        return this.editedIndex === -1 ? 'Add Match Fixtures' : 'Update Match Fixtures'
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
        
       	axios.get('/api/matches/getmatch').
       	then(res=>{
       	  
       	 this.matches=res.data.matches; 
          this.teams=res.data.teams;
       	 	}).catch(err=>console.dir(err));
      },

      editItem (item) {
      
        this.editedIndex = item.id
        this.editedItem = Object.assign({}, item)
        this.matchdialog = true
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
       this.matchdialog = false
        setTimeout(() => {
          this.editedItem = Object.assign({}, this.defaultItem)
          this.editedIndex = -1
        }, 300)
      },
        savematch ()
        {
           
           axios.post('/api/match/updatefixtures',{'id':this.editedItem.id,'winner_team':this.radios,'completed':this.status}).
           then(res=>{
          
         this.msg="Match status updated successfully";
         this.snackbar=true;
         this.initialize();
        
        }).catch(err=>console.dir(err)); 
          this.close()
        },
      save () {
        if (this.editedIndex > -1) {
        alert("indie");
        return false;
        //Edit Dialog here//          

        } else {
           
            axios.post('/api/match/addfixtures',{'teamA':this.editedItem.teamA,'teamB':this.editedItem.teamB,'date':this.editedItem.matchdate,'location':this.editedItem.location}).
           then(res=>{
          
         this.msg="Record added successfully";
         this.snackbar=true;
         this.initialize();
        }).catch(err=>console.dir(err));

        }
        this.close()
      },
    },
  }
</script>
<style scoped></style>