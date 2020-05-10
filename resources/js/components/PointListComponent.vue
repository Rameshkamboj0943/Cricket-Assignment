<template>
<v-col>
<v-data-table
    :headers="headers"
    :items="users"
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
        <v-toolbar-title>Points Table</v-toolbar-title>
        <v-divider
          class="mx-4"
          inset
          vertical
        ></v-divider>
        <v-spacer></v-spacer>
        
      </v-toolbar>
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
      dialog: false,
      loading:false,
      headers: [
        
        { text: 'Team Name', value: 'teamA' },
        { text: 'Match Win', value: 'matchwin' },
        { text: 'Match Lost', value: 'matchlost' },
        { text: 'Total Points', value: 'totalpoint' },
         
         ],
      users: [],
      editedIndex: -1,
      editedItem: {
        id: '',
        name: 0,
        email: 0,
        api_token: 0,
      
      },
      defaultItem: {
        id: '',
        name: 0,
        email: 0,
        api_token: 0,
        
      },
    }),

    computed: {
      formTitle () {
        return this.editedIndex === -1 ? 'Add User' : 'Edit User'
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
        
       	axios.get('/api/points/getpoint').
       	then(res=>{
       	  
       	 this.users=res.data.points; 
       	 
       	}).catch(err=>console.dir(err));
      },

     

      close () {
        this.dialog = false
        setTimeout(() => {
          this.editedItem = Object.assign({}, this.defaultItem)
          this.editedIndex = -1
        }, 300)
      },

     
    },
  }
</script>
<style scoped></style>