<template>
    <div>
    <v-container>
        <v-alert type="info">Hi RameshM</v-alert>
        <v-btn link to="/foo">Load Foo</v-btn>
        <v-btn link to="/bar">Load bar</v-btn>
        <v-btn link to="/user/ramesh">Load User</v-btn>
        
    </v-container>
    <v-container>
        <router-view></router-view>
    </v-container>
</div>
</template>

<script>
    export default {
        mounted() {
            console.log('Component mounted.')
        }
    }
</script>
