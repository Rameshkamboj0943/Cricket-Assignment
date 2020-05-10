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
   

        
          <router-view></router-view>
       
     
    </v-content>
  </v-app>

</template>
<script>
export default{
	
	props: {
      source: String,
    },
    data: () => ({
      drawer: null,
      items: [
        { icon: 'mdi-trending-up', action:'/admin/teams',text: 'Teams' },
        { icon: 'mdi-youtube-subscription', action:'/admin/players', text: 'Players' },
        { icon: 'mdi-history', action:'/admin/matches',text: 'Matches' },
        { icon: 'mdi-playlist-play',action:'/admin/points', text: 'Points' },
         ],
     
    }),
    created () {
      this.$vuetify.theme.dark = true
    },
}
</script>
<style scoped></style>