<script setup>
import { useRouter } from 'vue-router';
import Button from 'dashboard/components-next/button/Button.vue';

const router = useRouter();

const openProfileSettings = () => {
  return router.push({ name: 'profile_settings_index' });
};
</script>

<template>
  <div
    class="my-0 mx-4 px-1 flex max-h-[8vh] items-baseline justify-between hover:bg-n-slate-1 border border-dashed border-n-weak rounded-sm overflow-auto"
  >
    <p class="w-fit !m-0">
      {{ $t('CONVERSATION.FOOTER.MESSAGE_SIGNATURE_NOT_CONFIGURED') }}

      <Button
        link
        :label="$t('CONVERSATION.FOOTER.CLICK_HERE')"
        @click="openProfileSettings"
      />
    </p>
  </div>
</template>
