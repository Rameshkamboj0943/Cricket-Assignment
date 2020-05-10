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
        <v-toolbar-title>Match List</v-toolbar-title>
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
        
        { text: 'Team B Logo', value: 'teamBLogo' },
        { text: 'Team B', value: 'teamB' },
        { text: 'Date Time', value: 'matchdate' },
        { text: 'Location', value: 'location' },
        { text: 'Winner', value: 'winnerteam' },
       
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
        
       	axios.get('/api/matches/getmatchlist').
       	then(res=>{
       	  
       	 this.matches=res.data.matches; 
          this.teams=res.data.teams;
       	 	}).catch(err=>console.dir(err));
      },

      
    },
  }
</script>
<style scoped></style>