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
        <v-toolbar-title>Team Player List</v-toolbar-title>
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
        
      </v-toolbar>
    </template>
    <template v-slot:item.imageUri="{ item }">
            <div class="p-2">
              <v-img :src="'../storage/'+item.imageUri" :alt="item.firstName" width="50px" height="50px"></v-img>
            </div>
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
        ],
      players: [],
      teams:[],
      logoUri:null,
      editedIndex: -1,
      
    }),
    mounted () {
    this.getUser(this.$route.params.id);
    },
    computed: {
      formTitle () {
        return this.editedIndex === -1 ? 'Add Player' : 'Edit Player'
      },
    },

    watch: {
      dialog (val) {
        val || this.close()
      },
      '$route.params.id'(newId, oldId) {
        this.getUser(newId)
    }
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
        
       	 },
      getUser (id){
      this.loading=true;
       axios.get('/api/players/getteamplayer/'+id).
        then(res=>{
          this.loading=false;
         this.players=res.data.players; 
         this.teams=res.data.teams;
          }).catch(err=>console.dir(err));
     },
      

    },
  }
</script>
<style scoped></style>