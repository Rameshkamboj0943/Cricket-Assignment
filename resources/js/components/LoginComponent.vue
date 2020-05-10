<template>
<v-app id="inspire">
    <v-content>
      <v-container
        class="fill-height"
        fluid
      >
        <v-row
          align="center"
          justify="center"
        >
          <v-col
            cols="12"
            sm="8"
            md="4"
          >
            <v-card class="elevation-12">
              <v-toolbar
                color="error"
                dark
                flat
              >
                <v-toolbar-title>Login form</v-toolbar-title>
                <v-spacer />
                
                
              </v-toolbar>

              <v-card-text>
              <v-progress-linear
	       		 :active="loading"
	        		:indeterminate="loading"
	        		absolute
	       		 bottom
	       		 color="deep-purple accent-4">
	       		 </v-progress-linear>
                <v-form
                ref="form"
      			v-model="valid"
                >
                  <v-text-field
                    label="Login"
                    name="login" 
                    v-model="email"
                    :rules="emailRules"
                    prepend-icon="mdi-email"
                    type="text"
                    required
                  />

                  <v-text-field
                    id="password"
                    label="Password"
                    name="password"
                    v-model="password"
                    prepend-icon="mdi-lock"
                    :rules="passwordRules"
                    type="password"
                    required
                  />
                </v-form>
              </v-card-text>
              <v-card-actions>
                <v-spacer />
                <v-btn color="error" :disabled="!valid" @click="login">Login</v-btn>
              </v-card-actions>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-content>
  </v-app>

</template>
<script>
export default{
	
	data(){
		
	return {
		valid: true,
      email: '',
      emailRules: [
        v => !!v || 'E-mail is required',
        v => /.+@.+\..+/.test(v) || 'E-mail must be valid'
      ],
      password:'',
      passwordRules:[
      v => !!v || 'E-mail is required'
      ],

      loading:false,
      }
    },
    methods:
    {
     login:function()
     {
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
        
       	axios.post('/api/login',{'email':this.email,'password':this.password}).
       	then(res=>{
       	  
       	  
       	  localStorage.setItem('token',res.data.token);
       	  this.$router.push('/admin').then('').catch('');
       	}).catch(err=>console.dir(err));
      
     } 
    }
    
}
</script>
<style scoped></style>